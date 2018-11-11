package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

import java.util.Optional;

public class GoogleSheetsString {
    @SerializedName("$t")
    private String value;

    public Optional<String> resolvedValue() {
        return Optional.ofNullable(value).filter(v -> v.length() > 0);
    }
}
