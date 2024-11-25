import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Methods {
  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  /// Returns an [Image] widget displaying a player's headshot based on their name.
  ///
  /// The player's name is split into a list of strings [nameSplit], where the
  /// first element is the player's first name and the second element is the
  /// player's last name. The image is retrieved from the assets folder
  /// 'assets/player_headshots/' using a filename formatted as
  /// 'FirstName_LastName.png'. If the image asset does not exist, a default
  /// 'Blank.png' image is displayed instead.
  ///
  /// [nameSplit] A list containing the first and last name of the player.
  ///
  /// Returns an [Image] widget displaying the player's headshot or a default
  /// image if the specific headshot is not found.
  static Image getPlayerImage(List<String> nameSplit) {
    var path =
        'assets/player_headshots/${capitalize(nameSplit[0])}_${nameSplit[1]}.png';

    return Image.asset(
      path,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('assets/player_headshots/Blank.png');
      },
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
