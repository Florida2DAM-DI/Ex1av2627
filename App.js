import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View } from "react-native";

const App = () => {
  /* No toqueu este obtecte d'imatges */
  const imatges = {
    "zelda.jpg": require("./assets/games/zelda.jpg"),
    "minecraft.jpg": require("./assets/games/minecraft.jpg"),
    "fc27.jpg": require("./assets/games/fc27.jpg"),
    "mario.jpg": require("./assets/games/mario.jpg"),
    "godofwar.jpg": require("./assets/games/godofwar.jpg"),
    "cyberpunk.jpg": require("./assets/games/cyberpunk.jpg"),
  };

  return (
    <View style={styles.container}>
      <Text>Examen Din 1a AV. </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});

export default App;
