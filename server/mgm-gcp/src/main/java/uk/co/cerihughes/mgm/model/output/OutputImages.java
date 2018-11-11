package uk.co.cerihughes.mgm.model.output;

import com.google.gson.annotations.SerializedName;

public class OutputImages {
    @SerializedName("size64")
    private String size64;
    @SerializedName("size300")
    private String size300;
    @SerializedName("size640")
    private String size640;

    public String getSize64() {
        return size64;
    }

    public void setSize64(String size64) {
        this.size64 = size64;
    }

    public String getSize300() {
        return size300;
    }

    public void setSize300(String size300) {
        this.size300 = size300;
    }

    public String getSize640() {
        return size640;
    }

    public void setSize640(String size640) {
        this.size640 = size640;
    }
}
