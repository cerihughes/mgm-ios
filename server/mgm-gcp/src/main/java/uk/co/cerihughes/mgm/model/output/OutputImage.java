package uk.co.cerihughes.mgm.model.output;

import com.google.gson.annotations.SerializedName;

public class OutputImage {
    @SerializedName("size")
    private int size;
    @SerializedName("url")
    private String url;

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
