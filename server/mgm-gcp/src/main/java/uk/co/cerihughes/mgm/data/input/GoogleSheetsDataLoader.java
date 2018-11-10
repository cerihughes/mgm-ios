package uk.co.cerihughes.mgm.data.input;

import java.io.IOException;

public interface GoogleSheetsDataLoader {
    String loadJsonData() throws IOException;
}