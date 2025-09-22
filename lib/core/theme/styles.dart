import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_colors.dart';

class Styles {
  static final title = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: CustomColors.textDark,
  );

  static final body = GoogleFonts.poppins(
    fontSize: 14,
    color: CustomColors.textDark,
  );

  static final subtitle = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: CustomColors.primaryDark,
  );

  // Post Title
  static final TextStyle postTitle = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // Post body
  static final TextStyle postBody = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  // Subtitle / section title
  static final TextStyle postSubtitle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Tags
  static final TextStyle tagText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: CustomColors.primaryDark,
  );

  // Reactions & Favorite
  static final TextStyle reactionText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static final TextStyle favoriteText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: CustomColors.primary,
  );
}
