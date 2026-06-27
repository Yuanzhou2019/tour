import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { User } from '../types';

interface AuthState {
  user: User | null;
  isAuthed: boolean;
  setAuth: (user: User) => void;
  clear: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      isAuthed: false,
      setAuth: (user: User) => set({ user, isAuthed: true }),
      clear: () => set({ user: null, isAuthed: false }),
    }),
    {
      name: 'sightour-admin-auth',
    },
  ),
);
