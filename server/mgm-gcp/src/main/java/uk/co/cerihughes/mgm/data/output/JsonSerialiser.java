package uk.co.cerihughes.mgm.data.output;

import uk.co.cerihughes.mgm.model.output.OutputEvent;

import java.util.List;

interface JsonSerialiser {
    String serialise(List<OutputEvent> events);
}
