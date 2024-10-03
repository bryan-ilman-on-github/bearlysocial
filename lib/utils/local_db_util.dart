import 'package:bearlysocial/schemas/transaction.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// This class provides utility functions to interact with the local database.
class LocalDatabaseUtility {
  /// Establishes a connection to the local database.
  ///
  /// This function opens the local database in the application's document directory.
  /// It is asynchronous and must be called before performing any other database operations.
  static Future<void> createConnection() async {
    final dir = await getApplicationDocumentsDirectory();

    await Isar.open(
      [TransactionSchema],
      directory: dir.path,
    );
  }

  /// Inserts a single transaction into the local database.
  ///
  /// The `key` parameter is the unique identifier for the transaction, and it is hashed using the `_crc32` function.
  /// The `value` parameter is the data associated with the transaction.
  ///
  /// This function requires an active database connection and performs the write operation synchronously.
  static void insertTransaction({
    required String key,
    required String value,
  }) {
    final Isar? dbConnection = Isar.getInstance();

    Transaction transaction = Transaction()
      ..key = _crc32(key)
      ..value = value;

    dbConnection?.writeTxnSync(
      () => dbConnection.transactions.putSync(transaction),
    );
  }

  /// Inserts multiple transactions into the local database.
  ///
  /// The `pairs` parameter is a map of key-value pairs where each key is hashed using the `_crc32` function.
  /// Each key-value pair is inserted as a separate transaction.
  ///
  /// This function requires an active database connection and performs the write operation synchronously.
  static void insertTransactions({
    required Map<String, String> pairs,
  }) {
    final Isar? dbConnection = Isar.getInstance();

    List<Transaction> transactions = pairs.entries.map((entry) {
      return Transaction()
        ..key = _crc32(entry.key)
        ..value = entry.value;
    }).toList();

    dbConnection?.writeTxnSync(
      () => dbConnection.transactions.putAllSync(transactions),
    );
  }

  /// Retrieves a single transaction from the local database.
  ///
  /// The `key` parameter is the unique identifier for the transaction, and it is hashed using the `_crc32` function.
  /// The function returns the `value` associated with the transaction if found, or an empty string if no transaction is found.
  ///
  /// This function requires an active database connection and performs the read operation synchronously.
  static String retrieveTransaction({
    required String key,
  }) {
    final Isar? dbConnection = Isar.getInstance();

    final int hash = _crc32(key);
    final Transaction? transaction = dbConnection?.transactions.getSync(hash);

    return transaction?.value ?? '';
  }

  /// Retrieves multiple transactions from the local database.
  ///
  /// The `keys` parameter is a list of unique identifiers for transactions, each hashed using the `_crc32` function.
  /// The function returns a list of `values` associated with the transactions in the same order as the provided keys.
  /// If a transaction is not found for a key, an empty string is returned for that key.
  ///
  /// This function requires an active database connection and performs the read operation synchronously.
  static List<String> retrieveTransactions({
    required List<String> keys,
  }) {
    final dbConnection = Isar.getInstance();

    final hashes = keys.map(_crc32).toList();
    final txns = dbConnection?.transactions.getAllSync(hashes);

    return txns?.map((txn) => txn?.value ?? '').toList() ?? [];
  }

  /// Clears all data from the local database.
  ///
  /// This function removes all transactions and resets the local database.
  /// It requires an active database connection and performs the operation synchronously.
  static void emptyDatabase() {
    final Isar? dbConnection = Isar.getInstance();
    dbConnection?.writeTxnSync(() => dbConnection.clearSync());
  }
}

/// Computes a CRC32 hash for a given string input.
///
/// This function generates a 32-bit cyclic redundancy check (CRC32) hash for the input string,
/// which is used as a key in the local database for efficient lookup.
int _crc32(String input) {
  const int crc32Polynomial = 0xEDB88320;
  int crc = 0xFFFFFFFF;

  for (int i = 0; i < input.length; i++) {
    int byte = input.codeUnitAt(i);
    crc ^= byte;

    for (int j = 0; j < 8; j++) {
      if ((crc & 1) != 0) {
        crc = (crc >> 1) ^ crc32Polynomial;
      } else {
        crc >>= 1;
      }
    }
  }
  return crc ^ 0xFFFFFFFF;
}
