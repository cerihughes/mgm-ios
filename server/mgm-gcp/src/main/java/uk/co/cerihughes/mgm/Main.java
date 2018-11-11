package uk.co.cerihughes.mgm;

import uk.co.cerihughes.mgm.data.input.GoogleSheetsDataConverterImpl;
import uk.co.cerihughes.mgm.data.input.GoogleSheetsDataLoaderImpl;
import uk.co.cerihughes.mgm.data.output.JsonSerialiserImpl;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.output.OutputEvent;
import uk.co.cerihughes.mgm.translate.spotify.SpotifyTranslation;

import java.io.IOException;
import java.util.List;

public class Main {
    public static void main(String[] args) throws IOException {
        final GoogleSheetsDataLoaderImpl loader = new GoogleSheetsDataLoaderImpl();
        final String input = loader.loadJsonData();

        final GoogleSheetsDataConverterImpl converter = new GoogleSheetsDataConverterImpl();
        final List<InterimEvent> interimEvents = converter.convert(input);

        final SpotifyTranslation translation = new SpotifyTranslation();
        final List<OutputEvent> outputEvents = translation.translate(interimEvents);

        final JsonSerialiserImpl serialiser = new JsonSerialiserImpl();
        final String output = serialiser.serialise(outputEvents);
        System.out.println(output);
    }
}
