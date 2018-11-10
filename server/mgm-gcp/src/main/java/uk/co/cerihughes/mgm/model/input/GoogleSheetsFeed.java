package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class GoogleSheetsFeed {
    @SerializedName("entry")
    private List<GoogleSheetsEntry> entries;

    public List<GoogleSheetsEntry> getEntries() {
        return entries;
    }

    public void setEntries(List<GoogleSheetsEntry> entries) {
        this.entries = entries;
    }
}
