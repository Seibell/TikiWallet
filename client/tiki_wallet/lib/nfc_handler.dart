import 'dart:convert';
import 'dart:typed_data';
import 'package:nfc_manager/nfc_manager.dart';
import 'transaction.dart';

class NfcHandler {
  Future<void> writeTransactionToNfc(Transaction transaction) async {
    final jsonStr = json.encode(transaction.toJson());
    final payload = Uint8List.fromList(utf8.encode(jsonStr));

    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        throw Exception('Tag is not ndef writable');
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createMime('application/json', payload),
      ]);

      try {
        await ndef.write(message);
        NfcManager.instance.stopSession();
      } catch (e) {
        NfcManager.instance.stopSession(errorMessage: e.toString());
        rethrow;
      }
    });
  }

  Future<String> readTransactionFromNfc() async {
    String status = "DENIED";

    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef != null) {
        final records = ndef.cachedMessage?.records ?? [];
        bool transactionFound = false;
        for (var record in records) {
          if (record.typeNameFormat == 2 &&
              utf8.decode(record.type) == 'application/json') {
            transactionFound = true;
            final payload = record.payload;
            final jsonStr = utf8.decode(payload);
            final transactionData =
                json.decode(jsonStr) as Map<String, dynamic>;
            Transaction transaction = Transaction.fromJson(transactionData);

            // if (transaction.approved == true) {
            //   status = "APPROVED";
            // }
          }
        }
        if (!transactionFound) {
          throw Exception('No transaction found');
        }
      } else {
        throw Exception('No NFC tag detected');
      }

      NfcManager.instance.stopSession();
    });

    return status;
  }
}
