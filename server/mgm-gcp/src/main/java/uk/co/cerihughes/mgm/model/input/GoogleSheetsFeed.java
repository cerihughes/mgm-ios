package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

import java.util.Collections;
import java.util.List;

public class GoogleSheetsFeed {
    @SerializedName("entry")
    private List<GoogleSheetsEntry> entries;

    public List<GoogleSheetsEntry> resolvedEntries() {
        return entries == null ? Collections.emptyList() : entries;
    }
}
