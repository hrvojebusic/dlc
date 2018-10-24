package hr.fer.rgkk.transactions;

import org.bitcoinj.core.ECKey;
import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.crypto.TransactionSignature;
import org.bitcoinj.script.Script;
import org.bitcoinj.script.ScriptBuilder;

import static org.bitcoinj.script.ScriptOpCodes.*;

/**
 * You must implement standard Pay-2-Public-Key-Hash transaction type.
 */
public class PayToPubKeyHash extends ScriptTransaction {

    private final ECKey key;

    public PayToPubKeyHash(WalletKit walletKit, NetworkParameters parameters) {
        super(walletKit, parameters);
        key = getWallet().freshReceiveKey();
    }

    @Override
    public Script createLockingScript() {
        // TODO: Create Locking script
        return new ScriptBuilder()
                .op(OP_DUP)
                .op(OP_HASH160)
                .data(key.getPubKeyHash())
                .op(OP_EQUALVERIFY)
                .op(OP_CHECKSIG)
                .build();
    }

    @Override
    public Script createUnlockingScript(Transaction unsignedTransaction) {
        // TODO: Create Unlocking script
        TransactionSignature txSig = sign(unsignedTransaction, key);
        return new ScriptBuilder()
                .data(txSig.encodeToBitcoin())
                .data(key.getPubKey())
                .build();
    }
}
