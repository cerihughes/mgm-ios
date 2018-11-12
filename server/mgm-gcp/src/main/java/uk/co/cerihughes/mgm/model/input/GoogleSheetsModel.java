package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

public class GoogleSheetsModel {
    @SerializedName("feed")
    private GoogleSheetsFeed feed;

    public GoogleSheetsFeed getFeed() {
        return feed;
    }
}
