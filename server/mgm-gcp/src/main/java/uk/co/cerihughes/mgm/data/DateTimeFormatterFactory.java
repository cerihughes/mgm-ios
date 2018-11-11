package uk.co.cerihughes.mgm.data;

import java.time.format.DateTimeFormatter;

public interface DateTimeFormatterFactory {
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
}
