import 'dart:convert';

import 'package:bearlysocial/schemas/transaction.dart';
import 'package:hashlib/hashlib.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// This class handles all database operations for the application.
class DatabaseOperation {
  /// Creates a connection to the Isar database.
  ///
  /// This function is asynchronous and returns a Future that completes when the connection is established.
  static Future<void> createConnection() async {
    final dir = await getApplicationDocumentsDirectory();

    await Isar.open(
      [TransactionSchema],
      directory: dir.path,
    );
  }

  static void insertTransaction({
    required String key,
    required String value,
  }) {
    final Isar? dbConnection = Isar.getInstance();

    Transaction transaction = Transaction()
      ..key = crc32code(key)
      ..value = value;

    dbConnection?.writeTxnSync(
      () => dbConnection.transactions.putSync(transaction),
    );
  }

  /// Inserts transactions into the database.
  ///
  /// The `pairs` parameter is a map of key-value pairs to be inserted as transactions.
  static void insertTransactions({
    required Map<String, String> pairs,
  }) {
    final Isar? dbConnection = Isar.getInstance();

    List<Transaction> transactions = pairs.entries.map((entry) {
      return Transaction()
        ..key = crc32code(entry.key)
        ..value = entry.value;
    }).toList();

    dbConnection?.writeTxnSync(
      () => dbConnection.transactions.putAllSync(transactions),
    );
  }

  static String retrieveTransaction({
    required String key,
  }) {
    final Isar? dbConnection = Isar.getInstance();

    final int hash = crc32code(key);
    final Transaction? transaction = dbConnection?.transactions.getSync(hash);

    return transaction?.value ?? '';
  }

  /// Retrieves transactions from the database.
  ///
  /// This function returns a list of transactions.
  ///
  /// The `keys` parameter is a list of keys for the transactions to be retrieved.
  static List<String> retrieveTransactions({
    required List<String> keys,
  }) {
    final dbConnection = Isar.getInstance();

    final hashes = keys.map(crc32code).toList();
    final txns = dbConnection?.transactions.getAllSync(hashes);

    return txns?.map((txn) => txn?.value ?? '').toList() ?? [];
  }

  /// Generates a SHA-256 hash of the input string.
  ///
  /// The `input` parameter is the string to be hashed.
  static String getSHA256({
    required String input,
  }) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Empties the database.
  static void emptyDatabase() {
    final Isar? dbConnection = Isar.getInstance();
    dbConnection?.writeTxnSync(() => dbConnection.clearSync());
  }
}
