package hr.fer.rgkk.transactions;

import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.script.Script;
import org.bitcoinj.script.ScriptBuilder;

import static org.bitcoinj.script.ScriptOpCodes.*;

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

    private final Integer x=-1424;
    private final Integer y=1460;
    private final Integer fst=36;
    private final Integer lst=2884;

    public LinearEquationTransaction(WalletKit walletKit, NetworkParameters parameters) {
        super(walletKit, parameters);
    }

    @Override
    public Script createLockingScript() {
        // TODO: Create Locking script
        return new ScriptBuilder()
                .op(OP_2DUP)
                .op(OP_ADD)
                .number(fst)
                .op(OP_EQUALVERIFY)
                .op(OP_SUB)
                .op(OP_ABS)
                .number(lst)
                .op(OP_EQUAL)
                .build();
    }

    @Override
    public Script createUnlockingScript(Transaction unsignedScript) {
        // TODO: Create Unlocking script
        return new ScriptBuilder()
                .number(x)
                .number(y)
                .build();
    }
}
