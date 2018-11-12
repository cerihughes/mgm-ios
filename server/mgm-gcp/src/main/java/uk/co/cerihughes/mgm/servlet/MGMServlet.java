package uk.co.cerihughes.mgm.servlet;

import uk.co.cerihughes.mgm.data.input.GoogleSheetsDataConverterImpl;
import uk.co.cerihughes.mgm.data.input.GoogleSheetsDataLoaderImpl;
import uk.co.cerihughes.mgm.data.output.JsonSerialiserImpl;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.output.OutputEvent;
import uk.co.cerihughes.mgm.translate.spotify.SpotifyTranslation;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class MGMServlet extends HttpServlet {
    private static final long MILLIS_IN_HOUR = 1000 * 60 * 60;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        final GoogleSheetsDataLoaderImpl loader = new GoogleSheetsDataLoaderImpl();
        final String input = loader.loadJsonData();

        final GoogleSheetsDataConverterImpl converter = new GoogleSheetsDataConverterImpl();
        final List<InterimEvent> interimEvents = converter.convert(input);

        final SpotifyTranslation translation = new SpotifyTranslation();
        final List<OutputEvent> outputEvents = translation.translate(interimEvents);

        final JsonSerialiserImpl serialiser = new JsonSerialiserImpl();
        final String output = serialiser.serialise(outputEvents);

        long expires = getLastModified(request) + MILLIS_IN_HOUR;

        response.setContentType("application/json");
        response.setDateHeader("Expires", expires);
        response.setHeader("ETag", String.valueOf(expires));

        PrintWriter out = response.getWriter();
        out.write(output);
        out.flush();
    }

    @Override
    protected long getLastModified(HttpServletRequest request) {
        long now = System.currentTimeMillis();
        long mod = now % MILLIS_IN_HOUR;
        return now - mod;
    }
}