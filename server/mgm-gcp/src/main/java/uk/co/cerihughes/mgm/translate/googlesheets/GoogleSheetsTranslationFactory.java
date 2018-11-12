package uk.co.cerihughes.mgm.translate.googlesheets;

import uk.co.cerihughes.mgm.translate.AlbumTranslation;

public class GoogleSheetsTranslationFactory {
    public static AlbumTranslation createAlbumTranslation() {
        return new GoogleSheetsAlbumTranslation();
    }
}
