package uk.co.cerihughes.mgm.data.output;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import uk.co.cerihughes.mgm.data.DateTimeFormatterFactory;
import uk.co.cerihughes.mgm.model.output.OutputEvent;

import java.time.LocalDate;
import java.util.List;

public class JsonSerialiserImpl implements JsonSerialiser {
    private Gson gson = new GsonBuilder()
            .setPrettyPrinting()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter(DateTimeFormatterFactory.formatter).nullSafe())
            .create();

    @Override
    public String serialise(List<OutputEvent> events) {
        return gson.toJson(events);
    }
}
