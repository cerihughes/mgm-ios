package uk.co.cerihughes.mgm.android.model

import org.koin.test.KoinTest

fun KoinTest.createEvent(number: Int, classicAlbumScore: Float, newAlbumScore: Float, locationName: String? = null): Event {
    val classicAlbum = createAlbum(AlbumType.CLASSIC, score = classicAlbumScore)
    val newAlbum = createAlbum(AlbumType.NEW, score = newAlbumScore)
    return createEvent(number, classicAlbum, newAlbum, locationName)
}

fun KoinTest.createEventByAlbumName(number: Int, classicAlbumName: String, newAlbumName: String, locationName: String? = null): Event {
    val classicAlbum = createAlbum(AlbumType.CLASSIC, name = classicAlbumName)
    val newAlbum = createAlbum(AlbumType.NEW, name = newAlbumName)
    return createEvent(number, classicAlbum, newAlbum, locationName)
}

fun KoinTest.createEventByAlbumArtist(number: Int, classicAlbumArtist: String, newAlbumArtist: String, locationName: String? = null): Event {
    val classicAlbum = createAlbum(AlbumType.CLASSIC, artist = classicAlbumArtist)
    val newAlbum = createAlbum(AlbumType.NEW, artist = newAlbumArtist)
    return createEvent(number, classicAlbum, newAlbum, locationName)
}

fun KoinTest.createEvent(number: Int, classicAlbum: Album, newAlbum: Album, locationName: String? = null): Event {
    return Event(number, createLocation(locationName), null, null, classicAlbum, newAlbum)
}

fun KoinTest.createAlbum(type: AlbumType, name: String = "name", artist: String = "artist", score: Float = 5.0f): Album {
    return Album(type, null, name, artist, score, emptyList())
}

fun KoinTest.createLocation(locationName: String?): Location? {
    val locationName = locationName ?: return null
    return Location(locationName, 0.0, 0.0)
}
