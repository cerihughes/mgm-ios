package uk.co.cerihughes.mgm.translate.spotify;

import com.wrapper.spotify.model_objects.specification.Image;
import uk.co.cerihughes.mgm.model.output.OutputImage;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public abstract class SpotifyTranslation {
    protected boolean isValidData(String data) {
        return data != null && data.length() == 22;
    }

    protected List<OutputImage> getImages(Image[] spotifyImages) {
        if (spotifyImages == null || spotifyImages.length == 0) {
            return null;
        }

        return Arrays.stream(spotifyImages)
                .map(i -> createOutputImage(i))
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    private OutputImage createOutputImage(Image spotifyImage) {
        final Integer width = spotifyImage.getWidth();
        final Integer height = spotifyImage.getHeight();
        final String url = spotifyImage.getUrl();
        if (width == null && height == null) {
            return null;
        }

        int w = width == null ? 0 : width;
        int h = height == null ? 0 : height;
        int size = Math.max(w, h);

        return new OutputImage.Builder()
                .setSize(size)
                .setUrl(url)
                .build();
    }
}