package uk.co.cerihughes.mgm.data.input;

public class MissingRequiredDataException extends Exception {

    public MissingRequiredDataException(String message) {
        super(message);
    }

    public MissingRequiredDataException(Exception exception) {
        super(exception);
    }
}
