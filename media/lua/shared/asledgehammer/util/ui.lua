
-----------------------------------------------------------------

Font = {
  fonts_by_name = {
    small          = UIFont.Small         ,
    medium         = UIFont.Medium        ,
    large          = UIFont.Large         ,
    massive        = UIFont.Massive       ,
    mainmenu1      = UIFont.MainMenu1     ,
    mainmenu2      = UIFont.MainMenu2     ,
    cred1          = UIFont.Cred1         ,
    cred2          = UIFont.Cred2         ,
    newsmall       = UIFont.NewSmall      ,
    newmedium      = UIFont.NewMedium     ,
    newlarge       = UIFont.NewLarge      ,
    code           = UIFont.Code          ,
    mediumnew      = UIFont.MediumNew     ,
    autonormsmall  = UIFont.AutoNormSmall ,
    autonormmedium = UIFont.AutoNormMedium,
    autonormlarge  = UIFont.AutoNormLarge ,
    dialogue       = UIFont.Dialogue      ,
    intro          = UIFont.Intro         ,
    handwritten    = UIFont.Handwritten
  };
}
  
-----------------------------------------------------------------
-- TODO: Document.
-----------------------------------------------------------------
function getFont(str, fallback)
  
  if not fallback then fallback = Font.fonts_by_name['small'] end
    
  local f = string.lower(str);

  local font = Font.fonts_by_name[f];
  if font == nil then font = fallback end
  
  return font;

end
-----------------------------------------------------------------
