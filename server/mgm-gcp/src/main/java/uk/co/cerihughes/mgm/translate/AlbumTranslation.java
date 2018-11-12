package uk.co.cerihughes.mgm.translate;

import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.output.OutputAlbum;

import java.util.Optional;

public interface AlbumTranslation extends EntityTranslation {
    Optional<OutputAlbum> translate(InterimAlbum interimAlbum);
}
