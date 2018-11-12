package uk.co.cerihughes.mgm.translate;

import uk.co.cerihughes.mgm.model.interim.InterimEvent;

import java.util.List;

public interface EntityTranslation {
    void preprocess(List<InterimEvent> interimEvents);
}
