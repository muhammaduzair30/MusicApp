import uuid
from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile
from sqlalchemy import distinct
from sqlalchemy.orm import Session
from database import get_db
from middleware.auth_middleware import auth_middleware
import cloudinary
import cloudinary.uploader
from sqlalchemy.orm import joinedload
from models.favorite import Favorite
from models.song import Song
from pydantic_schemas.favorite_song import FavoriteSong
# from cloudinary.utils import cloudinary_url

router =APIRouter()

# Configuration       
cloudinary.config( 
    cloud_name = "diclhjzmc", 
    api_key = "159854838965627", 
    api_secret = "U_8Yfplgq-KgLZxmH8l9y7xsdpo", # Click 'View API Keys' above to copy your API secret
    secure= True
)

@router.post('/upload',status_code=201)
def upload_song(song: UploadFile= File(...), 
                thumbnail: UploadFile= File(...), 
                genre: str=Form(...), 
                artist: str=Form(...), 
                song_name: str=Form(...), 
                hex_code: str=Form(...), 
                db: Session = Depends(get_db),
                auth_dict = Depends(auth_middleware)):
    print("Received upload request.")
    print(f"Genre: {genre}") 
    song_id =str(uuid.uuid4())
    song_res= cloudinary.uploader.upload(song.file, resource_type = 'auto', folder= f'songs/{song_id}')

    thumbnail_res= cloudinary.uploader.upload(thumbnail.file, resource_type = 'image', folder= f'songs/{song_id}')
    
    song_url_https = song_res['url'].replace('http://', 'https://')
    thumbnail_url_https = thumbnail_res['url'].replace('http://', 'https://')
    
    
    new_song = Song(
        id=song_id,
        song_name=song_name,
        genre=genre,
        artist=artist,
        hex_code=hex_code,
        song_url= song_url_https,
        thumbnail_url =  thumbnail_url_https
    )
    
    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song

@router.get('/list')
def list_songs(db: Session =Depends(get_db), 
            auth_details = Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs

@router.post('/favorite')
def favorite_song(song: FavoriteSong, db: 
                Session=Depends(get_db), 
                auth_details = Depends(auth_middleware),):
    #song is already favorited by user
    user_id = auth_details['uid']
    
    fav_song= db.query(Favorite).filter(Favorite.song_id == song.song_id, Favorite.user_id ==user_id).first()
    
    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {'message': False}
    else:
        new_fav = Favorite(id=str(uuid.uuid4()), song_id=song.song_id, user_id=user_id)
        db.add(new_fav)
        db.commit()
        return {'message': True}
    
@router.get('/list/favorites')
def list_fav_songs(db: Session =Depends(get_db), 
            auth_details = Depends(auth_middleware)):
    user_id = auth_details['uid']
    fav_songs=db.query(Favorite).filter(Favorite.user_id ==user_id).options(
        joinedload(Favorite.song)
        ).all()
    
    return fav_songs


@router.get('/genre')
def list_of_genre(db: Session = Depends(get_db)):
    # Use the distinct() method directly on the query object
    genreList = db.query(Song.genre).distinct().all()
    
    # Extract genres from the list of tuples
    genres = [genre[0] for genre in genreList]

    return {'genre': genres}


@router.get('/genre/Songlist')
def get_genre_SongList (genre: str,db: Session = Depends(get_db)):
    
    songList = db.query(Song).filter(Song.genre == genre ).all()
    
    return {'songs': songList}


# @router.get('/search')
# def get_suggestions(words: str, db: Session = Depends(get_db)):
#     # Strip leading/trailing whitespace and convert to lowercase for consistency
#     words = words.strip().lower()

#     # Query for suggestions where the search term appears anywhere in any of the columns
#     suggestions = db.query(Song).filter(
#         (Song.song_name.ilike(f"%{words}%")) |
#         (Song.genre.ilike(f"%{words}%")) |
#         (Song.artist.ilike(f"%{words}%"))
#     ).all()

#     # If no suggestions found, raise HTTPException
#     if not suggestions:
#         raise HTTPException(status_code=404, detail="No suggestions found")

#     # Create a set to hold unique values that match the complete word input
#     result = set()

#     # Add values to the set only if they contain the exact input 'words' as a substring
#     for song in suggestions:
#         # Check if the entire input matches any part of song_name, artist, or genre
#         if words in song.song_name.lower():
#             result.add(song.song_name)
#         if words in song.artist.lower():
#             result.add(song.artist)
#         if words in song.genre.lower():
#             result.add(song.genre)

#     # Prepare the output as a list of dictionaries, maintaining only entries that match the entire input phrase
#     output = [{"name": value} for value in result if words in value.lower()]

#     return {'song': suggestions, 'suggestions': output}



@router.get('/search')
def get_suggestions(words: str, db: Session = Depends(get_db)):
    # Query for suggestions where any of the columns start with the search term
    print(words)
    suggestions = db.query(Song).filter(
        (Song.song_name.ilike(f"%{words}%")) |
        (Song.genre.ilike(f"%{words}%")) |
        (Song.artist.ilike(f"%{words}%"))
    ).all()

    # If no suggestions found, raise HTTPException
    if not suggestions:
        raise HTTPException(status_code=404, detail="No suggestions found")

    # Create a set to hold unique values
    result = set()

    # Add values to the set for uniqueness
    for song in suggestions:
        if song.song_name.lower():      #.startswith(words.lower()):
            result.add(song.song_name)
        if song.artist.lower():      #.startswith(words.lower()):
            result.add(song.artist)
        if song.genre.lower():      #.startswith(words.lower()):
            result.add(song.genre)

    # Prepare the output as a list of dictionaries
    output = [{"name": value} for value in result if words in value.lower()]
    
    # songs =  db.query(Song).filter(Song.song_name.ilike(f"{words}%")).all()
    songs =db.query(Song).filter(
        (Song.song_name.ilike(f"%{words}%")) |
        (Song.genre.ilike(f"%{words}%")) |
        (Song.artist.ilike(f"%{words}%"))
    ).all()

    return {'song':songs, 'suggestions':output}



