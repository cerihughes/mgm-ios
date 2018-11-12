package uk.co.cerihughes.mgm.translate;

import uk.co.cerihughes.mgm.model.interim.InterimPlaylist;
import uk.co.cerihughes.mgm.model.output.OutputPlaylist;

public interface PlaylistTranslation extends EntityTranslation {
    OutputPlaylist translate(InterimPlaylist interimPlaylist);
}
