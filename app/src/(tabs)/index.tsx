import { Image } from 'expo-image';
import { StyleSheet } from 'react-native';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';

export default function HomeScreen() {
  return (
    <ThemedView style={styles.container}>
      <Image
        source={require('@/assets/images/logo.jpg')}
        style={styles.logo}
        contentFit="contain"
      />
      <ThemedText type="title" style={styles.message}>
        {'VOCÊ CONSEGUIU!\nTá tudo certo agora'}
      </ThemedText>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 24,
    gap: 20,
  },
  logo: {
    width: 180,
    height: 180,
  },
  message: {
    textAlign: 'center',
  },
});
