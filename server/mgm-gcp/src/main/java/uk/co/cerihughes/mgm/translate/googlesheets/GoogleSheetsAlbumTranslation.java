package uk.co.cerihughes.mgm.translate.googlesheets;

import com.google.gson.Gson;
import uk.co.cerihughes.mgm.model.input.*;
import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.output.OutputAlbum;
import uk.co.cerihughes.mgm.model.output.OutputImage;
import uk.co.cerihughes.mgm.translate.AlbumTranslation;

import java.util.List;
import java.util.Optional;
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
    public Optional<OutputAlbum> translate(InterimAlbum interimAlbum) {
        try {
            final GoogleSheetsAlbum album = deserialise(interimAlbum.getAlbumData());
            return new OutputAlbum.Builder(interimAlbum.getType(), album.getName(), album.getArtist())
                    .setScore(interimAlbum.getScore())
                    .setImages(getImages(album.getImages()))
                    .build();
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    private Optional<List<OutputImage>> getImages(List<GoogleSheetsImage> images) {
        if (images == null || images.isEmpty()) {
            return Optional.empty();
        }

        final List<OutputImage> outputImages = images.stream()
                .map(i -> createOutputImage(i))
                .filter(Optional::isPresent)
                .map(Optional::get)
                .collect(Collectors.toList());
        return Optional.of(outputImages);
    }

    private Optional<OutputImage> createOutputImage(GoogleSheetsImage image) {
        final Integer size = image.getSize();
        final String url = image.getUrl();
        if (size == null || url == null) {
            return Optional.empty();
        }

        return new OutputImage.Builder(size, url).build();
    }
}