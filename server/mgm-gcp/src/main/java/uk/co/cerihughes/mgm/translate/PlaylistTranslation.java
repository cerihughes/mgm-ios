package uk.co.cerihughes.mgm.translate;

import uk.co.cerihughes.mgm.model.interim.InterimPlaylist;
import uk.co.cerihughes.mgm.model.output.OutputPlaylist;

import java.util.Optional;

public interface PlaylistTranslation extends EntityTranslation {
    Optional<OutputPlaylist> translate(InterimPlaylist interimPlaylist);
}
