package hr.fer.rgkk.transactions;

import org.bitcoinj.core.ECKey;
import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.crypto.TransactionSignature;
import org.bitcoinj.script.Script;
import org.bitcoinj.script.ScriptBuilder;

import static org.bitcoinj.script.ScriptOpCodes.*;

/**
 * You must implement locking and unlocking script such that transaction output is locked by one mandatory authority
 * (e.g. bank) and at least 1 of 3 other authorities (e.g. bank associates).
 */
public class MultiSigTransaction extends ScriptTransaction {

    private final ECKey bank;
    private final ECKey fst;
    private final ECKey snd;
    private final ECKey trd;

    public MultiSigTransaction(WalletKit walletKit, NetworkParameters parameters) {
        super(walletKit, parameters);
        bank = getWallet().freshReceiveKey();
        fst = getWallet().freshReceiveKey();
        snd = getWallet().freshReceiveKey();
        trd = getWallet().freshReceiveKey();
    }

    @Override
    public Script createLockingScript() {
        // TODO: Create Locking script
        return new ScriptBuilder()
                .number(1)
                .data(bank.getPubKey())
                .number(1)
                .op(OP_CHECKMULTISIGVERIFY)
                .number(1)
                .data(fst.getPubKey())
                .data(snd.getPubKey())
                .data(trd.getPubKey())
                .number(3)
                .op(OP_CHECKMULTISIG)
                .build();
    }

    @Override
    public Script createUnlockingScript(Transaction unsignedTransaction) {
        // TODO: Please be aware of the OP_CHECK_MULTISIG bug!
        // TODO: Create Unlocking script
        TransactionSignature s_b = sign(unsignedTransaction, bank);
        // Uncomment 1 signature below
        TransactionSignature s_c = sign(unsignedTransaction, fst);
        //TransactionSignature s_c = sign(unsignedTransaction, snd);
        //TransactionSignature s_c = sign(unsignedTransaction, trd);
        return new ScriptBuilder()
                .number(42)
                .data(s_c.encodeToBitcoin())
                .number(42)
                .data(s_b.encodeToBitcoin())
                .build();
    }
}
