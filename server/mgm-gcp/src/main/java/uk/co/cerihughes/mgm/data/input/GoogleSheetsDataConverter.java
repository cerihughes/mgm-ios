package uk.co.cerihughes.mgm.data.input;

import uk.co.cerihughes.mgm.model.interim.InterimEvent;

import java.util.List;

public interface GoogleSheetsDataConverter {
    List<InterimEvent> convert(String json);
}
