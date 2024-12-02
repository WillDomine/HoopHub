import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Methods {
  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  /// Returns a [CachedNetworkImage] widget for the given player's image.
  ///
  /// The image is retrieved from the 'player_images' bucket in Supabase
  /// Storage. The path to the image is constructed by concatenating the
  /// first and last names of the player, separated by an underscore.
  ///
  /// A [CircularProgressIndicator] is used as a placeholder while the image
  /// is loading, and a blank image is used if the image fails to load.
  static CachedNetworkImage getPlayerImage(String name) {
    List<String> nameSplit = name.split(' ');
    var path = Supabase.instance.client.storage
        .from('player_images')
        .getPublicUrl('${nameSplit[0]}_${nameSplit[1]}.png');

    return CachedNetworkImage(
      imageUrl: path,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
          const Image(image: AssetImage('assets/player_headshots/Blank.png')),
    );
  }

  static CachedNetworkImage getTeamImage(String name) {
    var path = Supabase.instance.client.storage
        .from('team_images')
        .getPublicUrl('$name.png');
    return CachedNetworkImage(
      imageUrl: path,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
          const Icon(Icons.error, color: Colors.grey),
    );
  }

  /// Generates a list of [DropdownMenuItem]s for the season dropdown menu.
  ///
  /// The list starts with a "All Seasons" item and then contains each year
  /// from the current year down to 1947. The list is sorted in descending
  /// order.
  static List<DropdownMenuItem<String>> createSeasonDropdown() {
    List<DropdownMenuItem<String>> seasonsDropdownItems = [];
    var firstSeason = 1947;
    var lastSeason = DateTime.now().year + 1;

    for (var i = lastSeason; i >= firstSeason; i--) {
      seasonsDropdownItems.add(DropdownMenuItem(
        value: i.toString(),
        child: Text(i.toString()),
      ));
    }

    seasonsDropdownItems.insert(
        0,
        const DropdownMenuItem(
          value: '',
          child: Text('All Seasons'),
        ));
    return seasonsDropdownItems;
  }

  static List<DropdownMenuItem<String>> createTeamDropdown() {
    List<DropdownMenuItem<String>> teamsDropdownItems = [];
    Supabase.instance.client
        .from('teams')
        .select('abbreviation')
        .eq('season', '2025')
        .then((value) {
      for (var team in value) {
        teamsDropdownItems.add(DropdownMenuItem(
          value: team['abbreviation'],
          child: Text(team['abbreviation']),
        ));
      }
      teamsDropdownItems.insert(
          0,
          const DropdownMenuItem(
            value: '',
            child: Text('All Teams'),
          ));
    });
    return teamsDropdownItems;
  }
}
