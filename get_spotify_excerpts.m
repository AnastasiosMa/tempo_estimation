function y = get_spotify_excerpts(type,query)
% Download excerpts from Spotify API. Requires an account with Spotify
% API,you can register here: https://developer.spotify.com/dashboard/
%
%      type - specifies the type of data to retrieve based on query.
%      Available options are:
%
%
%       'track'      - retrieves a single track
%       'album'      - retrieves the tracks within the album
%       'artist'     - retrieves all tracks of given artist
%       'genre'      - retrieves track of that genre
%       'playlist'   - retrieves all tracks in playlists matching query
%       'playlistID' - retrieves all tracks in playlist matching playlist ID
%
%      query - the search word to be entered in Spotify's catalog
%
%      Anastasios Mavrolampados, Martin Hartmann - University of Jyvaskyla 2022
%

id =  '';%user ud
secret = ''; %user password
code = matlab.net.base64encode([id ':' secret]); %convert to base64




%establish connection with spotify api and get access token
postOptions = weboptions('HeaderFields',{'Authorization' ['Basic ' code]; ...
    'Content-Type' 'application/x-www-form-urlencoded'});
token = webwrite("https://accounts.spotify.com/api/token",'grant_type','client_credentials',postOptions);
options=weboptions('Timeout',Inf,'HeaderFields',{'Accept' 'application/json';...
    'Content-Type' 'application/json';'Authorization' ['Bearer ' token.access_token]});
base_url = 'https://api.spotify.com/v1';
url = [base_url '/search?type=' type '&q=' query];
%URL_track = "https://api.spotify.com/v1/tracks/2TpxZ7JUBn3uw46aR7qd6V"; %can be used for testing

%create structure with fields
fields = {'trackName','artistName','albumName','trackPreview'};
data = cell(length(fields),1);
data = cell2struct(data,fields);

genres_ids= {'toplists','Top Lists';'hiphop','Hip-Hop';'0JQ5DAqbMKFEC4WFtoNRpw','Pop';...
    '0JQ5DAqbMKFKLfwjuJMoNC','Country';'0JQ5DAqbMKFxXaXKP7zcDp','Latin';...
    '0JQ5DAqbMKFDXXwE9BDJAr','Rock';'0JQ5DAqbMKFLVaM30PMBm4','S';...
    '0JQ5DAqbMKFAXlCG6QvYQ4','Workout';'0JQ5DAqbMKFEZPnFQSFB1T','R&B';...
    '0JQ5DAqbMKFHOzuVTgTizF','Dance/Electronic';'0JQ5DAqbMKFEOEBCABAxo9','Netflix';...
    '0JQ5DAqbMKFCWjUTdzaG0e','Indie';'0JQ5DAqbMKFzHmL4tf05da','Mood';...
    '0JQ5DAqbMKFCuoRTxhYWow','Sleep';'0JQ5DAqbMKFy0OenPG51Av','Christian & Gospel';...
    '0JQ5DAqbMKFDTEtSaS4R92','Regional Mexican';'0JQ5DAqbMKFLb2EqgLtpjC','Wellness';...
    '0JQ5DAqbMKFFzDl7qN9Apr','Chill';'0JQ5DAqbMKFPw634sFwguI','EQUAL';...
    '0JQ5DAqbMKFCfObibaOZbv','Gaming';'0JQ5DAqbMKFF9bY76LXmfI','Frequency';...
    '0JQ5DAqbMKFF1br7dZcRtK','Pride';'0JQ5DAqbMKFFoimhOqWzLB','Kids & Family';...
    '0JQ5DAqbMKFA6SOHvT3gck','Party';'0JQ5DAqbMKFIVNxQgRNSg0','Decades';...
    '0JQ5DAqbMKFImHYGo3eTSg','Fresh Finds';'0JQ5DAqbMKFAJ5xb0fwo9m','Jazz';...
    '0JQ5DAqbMKFCbimwdOYlsl','Focus';'0JQ5DAqbMKFAUsdyVjCQuL','Romance';...
    '0JQ5DAqbMKFy78wprEpAjl','Folk & Acoustic';'0JQ5DAqbMKFGvOw3O4nLAf','K-Pop';...
    '0JQ5DAqbMKFRieVZLLoo9m','Instrumental';'sports','Sports';...
    '0JQ5DAqbMKFLjmiZRss79w','Ambient';'0JQ5DAqbMKFFtlLYUHv8bT','Alternative';...
    'in_the_car','In the car';'0JQ5DAqbMKFRNXsIvgZF9A','theLINER';...
    '0JQ5DAqbMKFPrEiAOxgac3','Classical';'0JQ5DAqbMKFIpEuaCnimBj','Soul';...
    '0JQ5DAqbMKFDBgllo2cUIN','Spotify Singles';'0JQ5DAqbMKFRY5ok2pxXJ0','Cooking & Dining';...
    '0JQ5DAqbMKFAjfauKLOZiv','Punk';'0JQ5DAqbMKFQIL0AXnG5AK','Pop culture';...
    '0JQ5DAqbMKFQiK2EHwyjcU','Blues';'0JQ5DAqbMKFQVdc2eQoH2s','Desi';...
    '0JQ5DAqbMKFQ1UFISXj59F','Arab';'0JQ5DAqbMKFOOxftoKZxod','RADAR';...
    '0JQ5DAqbMKFJw7QLnM27p6','Student';'0JQ5DAqbMKFziKOShCi009','Anime';...
    '0JQ5DAqbMKFRKBHIxJ5hMm','Tastemakers';'0JQ5DAqbMKFDkd668ypn6O','Metal';'funk','Funk';...
    'comedy','Comedy';'0JQ5DAqbMKFAQy4HL4XU2D','Travel';'0JQ5DAqbMKFNQ0fGp4byGU','Afro'};

if strcmpi(type,'track')
    response=webread(url,options);
    data(1).trackName = response.tracks.items(1).name;
    data(1).artistName = response.tracks.items(1).artists(1).name;
    data(1).albumName = response.tracks.items(1).album(1).name;
    data(1).trackPreview = response.tracks.items(1).preview_url;
elseif strcmpi(type,'album')
    response=webread(url,options);
    albumId = response.albums.items(1).id;
    response=webread([base_url '/albums/' albumId],options);
    for i = 1:size(response.tracks.items,1)
        data(i).trackName = response.tracks.items(i).name;
        data(i).artistName = response.tracks.items(i).artists(1).name;
        data(i).albumName = response.name;
        data(i).trackPreview = response.tracks.items(i).preview_url;
    end
elseif strcmpi(type,'artist')
    response=webread(url,options);
    artistId = response.artists.items(1).id;
    response=webread([base_url '/artists/' artistId '/albums'],options);
    for k = 1:size(response.items,1)
        albumId = response.items(k).id;
        response_album=webread([base_url '/albums/' albumId],options);
        for i = 1:size(response_album.tracks.items,1)
            data(end+1).trackName = response_album.tracks.items(i).name;
            data(end).artistName = response_album.tracks.items(i).artists(1).name;
            data(end).albumName = response_album.name;
            data(end).trackPreview = response_album.tracks.items(i).preview_url;
        end
    end
elseif strcmpi(type,'genre')
    idx=find(strcmpi(genres_ids(:,2),query));
    if isempty(idx)
        disp('Genre not available. Choose from the following categories:')
        disp(genres_ids(:,2))
    else
        url = [base_url '/browse/categories/' char(genres_ids(idx,1)) '/playlists'];
        response=webread(url,options);
        idxs = find(arrayfun(@(x) isstruct(x{:}),response.playlists.items)); %remove empty playlists
        response.playlists.items = response.playlists.items(idxs);
        for k = 1:size(response.playlists.items,1)
            response_playlist = webread([base_url '/users/spotify/playlists/' response.playlists.items{k}.id],options);
            for i = 1:size(response_playlist.tracks.items,1)
                if ~isempty(response_playlist.tracks.items(i).track)
                    data(end+1).trackName = response_playlist.tracks.items(i).track.name;
                    data(end).artistName = response_playlist.tracks.items(i).track.artists(1).name;
                    data(end).albumName = response_playlist.tracks.items(i).track.album(1).name;
                    data(end).trackPreview = response_playlist.tracks.items(i).track.preview_url;
                end
            end
        end
    end
elseif strcmpi(type,'playlist')
    response=webread(url,options);
    idxs = find(arrayfun(@(x) isstruct(x),response.playlists.items)); %remove empty playlists
    response.playlists.items = response.playlists.items(idxs);
    for k = 1:size(response.playlists.items,1)
        response_playlist = webread([base_url '/users/spotify/playlists/' response.playlists.items(k).id],options);
        for i = 1:size(response_playlist.tracks.items,1)
            if ~isempty(response_playlist.tracks.items(i).track)
                data(end+1).trackName = response_playlist.tracks.items(i).track.name;
                data(end).artistName = response_playlist.tracks.items(i).track.artists(1).name;
                data(end).albumName = response_playlist.tracks.items(i).track.album(1).name;
                data(end).trackPreview = response_playlist.tracks.items(i).track.preview_url;
            end
        end
    end
elseif strcmpi(type,'playlistID')
    offset = 0;
    while true
        response = webread(['https://api.spotify.com/v1/playlists/' query '/tracks?offset=' num2str(offset)],options);
        for i = 1:size(response.items,1)
            if ~isempty(response.items(i).track)
                data(end+1).trackName = response.items(i).track.name;
                data(end).artistName = response.items(i).track.artists(1).name;
                data(end).albumName = response.items(i).track.album(1).name;
                data(end).trackPreview = response.items(i).track.preview_url;
            end
        end
        if response.offset == response.total;
            break
        else
            offset = response.offset + 100;
        end
    end
else
    error('Incorrect input for type parameter')
end
idx=find(arrayfun(@(x) ~isempty(x.trackPreview),data)); %remove tracks with missing previews
if isempty(idx)
    disp('Tracks not found')
else
    data = data(idx);
    mkdir([type '_' query])
    cd([type '_' query])
    for i = 1:size(data,2)
        track=webread(data(i).trackPreview);
        fileName = erase([data(i).trackName '-' data(i).artistName '.mp4'],'/'); %remove '/' from string
        audiowrite(fileName,track,44100);
    end
end

end
