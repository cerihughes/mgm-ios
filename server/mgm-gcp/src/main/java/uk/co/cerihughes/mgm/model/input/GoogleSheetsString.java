package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

public class GoogleSheetsString {
    @SerializedName("$t")
    private String value;

    public String resolvedValue() {
        if (value == null || value.length() == 0) {
            return null;
        }
        return value;
    }
}
