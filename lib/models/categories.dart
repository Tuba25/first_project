// categories.dart
class Categories {
  final String image;
  final String text;

  const Categories({required this.image, required this.text});
}

// Define categories for both locations
final List<Categories> categoriesListAnikTower = [
  const Categories(image: "https://c4.wallpaperflare.com/wallpaper/165/200/910/food-pizza-cheese-wallpaper-preview.jpg", text: "Pizza"),
  const Categories(image: "https://www.wallpaperflare.com/static/211/4/925/food-burgers-burger-white-background-wallpaper.jpg", text: "Burger"),
  const Categories(image: "https://c4.wallpaperflare.com/wallpaper/503/768/942/food-chocolate-cake-cake-wallpaper-preview.jpg", text: "Dessert"),
];

final List<Categories> categoriesListSepalTower = [
  const Categories(image: "https://i.pinimg.com/736x/39/b0/fb/39b0fbd2c31083eb2e1f4ed4350cdcef.jpg", text: "Drinks"),
  const Categories(image: "https://c4.wallpaperflare.com/wallpaper/797/991/646/table-plate-rice-carrots-wallpaper-preview.jpg", text: "Rice"),
  const Categories(image: "https://c4.wallpaperflare.com/wallpaper/582/392/951/food-curry-shahi-paneer-hd-wallpaper-preview.jpg", text: "Curry"),
  const Categories(image: "https://c1.wallpaperflare.com/preview/285/112/28/curry-curry-beach-hotel-when-the-vegetables.jpg", text: "Veg"),
  const Categories(image: "https://c4.wallpaperflare.com/wallpaper/796/449/290/chicken-legs-close-up-three-plate-wallpaper-preview.jpg", text: "Chicken"),
];
