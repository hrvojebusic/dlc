package hr.fer.rgkk.transactions;

import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.script.Script;

/**
 * You must implement locking and unlocking script such that transaction output is locked by 2 integers x and y
 * such that they are solution to the equation system:
 * <pre>
 *     x + y = first four digits of your student id
 *     abs(x-y) = last four digits of your student id
 * </pre>
 * If needed change last digit of your student id such that x and y have same parity. This is needed so that equation
 * system has integer solutions.
 */
public class LinearEquationTransaction extends ScriptTransaction {

    public LinearEquationTransaction(WalletKit walletKit, NetworkParameters parameters) {
        super(walletKit, parameters);
    }

    @Override
    public Script createLockingScript() {
        // TODO: Create Locking script
        throw new UnsupportedOperationException();
    }

    @Override
    public Script createUnlockingScript(Transaction unsignedScript) {
        // TODO: Create Unlocking script
        throw new UnsupportedOperationException();
    }
}
