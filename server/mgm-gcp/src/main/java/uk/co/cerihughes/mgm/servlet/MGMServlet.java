package uk.co.cerihughes.mgm.servlet;

import uk.co.cerihughes.mgm.Main;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class MGMServlet extends HttpServlet {
    private static final long MILLIS_IN_HOUR = 1000 * 60 * 60;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        final String output = Main.execute();

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