package uk.co.cerihughes.mgm.translate.spotify;

import com.wrapper.spotify.model_objects.specification.Image;
import uk.co.cerihughes.mgm.model.output.OutputImage;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public abstract class SpotifyTranslation {
    protected boolean isValidData(String data) {
        return data != null && data.length() == 22;
    }

    protected Optional<List<OutputImage>> getImages(Image[] spotifyImages) {
        if (spotifyImages == null || spotifyImages.length == 0) {
            return Optional.empty();
        }

        final List<OutputImage> outputImages = Arrays.stream(spotifyImages)
                .map(i -> createOutputImage(i))
                .filter(Optional::isPresent)
                .map(Optional::get)
                .collect(Collectors.toList());
        return Optional.of(outputImages);
    }

    private Optional<OutputImage> createOutputImage(Image spotifyImage) {
        final Integer width = spotifyImage.getWidth();
        final Integer height = spotifyImage.getHeight();
        final String url = spotifyImage.getUrl();
        if ((width == null || height == null) || url == null) {
            return Optional.empty();
        }

        int w = width == null ? 0 : width;
        int h = height == null ? 0 : height;
        int size = Math.max(w, h);

        return new OutputImage.Builder(size, url).build();
    }
}