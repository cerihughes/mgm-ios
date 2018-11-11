package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

import java.util.Optional;

public class GoogleSheetsModel {
    @SerializedName("feed")
    private GoogleSheetsFeed feed;

    public Optional<GoogleSheetsFeed> getFeed() {
        return Optional.ofNullable(feed);
    }
}
