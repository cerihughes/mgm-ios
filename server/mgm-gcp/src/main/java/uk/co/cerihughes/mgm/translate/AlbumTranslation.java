package uk.co.cerihughes.mgm.translate;

import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.output.OutputAlbum;

public interface AlbumTranslation extends EntityTranslation {
    OutputAlbum translate(InterimAlbum interimAlbum);
}
