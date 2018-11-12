package uk.co.cerihughes.mgm.translate.googlesheets;

import com.google.gson.Gson;
import uk.co.cerihughes.mgm.model.input.GoogleSheetsAlbum;
import uk.co.cerihughes.mgm.model.input.GoogleSheetsImage;
import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.output.OutputAlbum;
import uk.co.cerihughes.mgm.model.output.OutputImage;
import uk.co.cerihughes.mgm.translate.AlbumTranslation;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class GoogleSheetsAlbumTranslation implements AlbumTranslation {
    private Gson gson = new Gson();

    private GoogleSheetsAlbum deserialise(String json) {
        return gson.fromJson(json, GoogleSheetsAlbum.class);
    }

    @Override
    public void preprocess(List<InterimEvent> interimEvents) {
        // No-op
    }

    @Override
    public OutputAlbum translate(InterimAlbum interimAlbum) {
        try {
            final GoogleSheetsAlbum album = deserialise(interimAlbum.getAlbumData());
            return new OutputAlbum.Builder()
                    .setType(interimAlbum.getType())
                    .setName(album.getName())
                    .setArtist(album.getArtist())
                    .setScore(interimAlbum.getScore())
                    .setImages(getImages(album.getImages()))
                    .build();
        } catch (Exception e) {
            return null;
        }
    }

    private List<OutputImage> getImages(List<GoogleSheetsImage> images) {
        if (images == null || images.isEmpty()) {
            return null;
        }

        return images.stream()
                .map(i -> createOutputImage(i))
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    private OutputImage createOutputImage(GoogleSheetsImage image) {
        final Integer size = image.getSize();
        final String url = image.getUrl();

        return new OutputImage.Builder()
                .setSize(size)
                .setUrl(url)
                .build();
    }
}