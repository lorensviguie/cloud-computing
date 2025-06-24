# Personnalisation WordPress
Placez ici votre thème personnalisé (dossier contenant style.css, functions.php, etc.), ou votre logo (ex: logo.png). Par exemple:

- custom-theme/
  - mytheme/
    - style.css
    - index.php
    - ...
  - logo.png

Lors de la construction de l'image, le Dockerfile copiera le thème dans `/usr/src/wordpress/wp-content/themes/mytheme` et le logo peut être placé dans `/usr/src/wordpress/wp-content/uploads/` selon vos besoins.