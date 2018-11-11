package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

public class GoogleSheetsFeed {
    @SerializedName("entry")
    private List<GoogleSheetsEntry> entries;

    public List<GoogleSheetsEntry> resolvedEntries() {
        return Optional.ofNullable(entries).orElse(Collections.emptyList());
    }
}
