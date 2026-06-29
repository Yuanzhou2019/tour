import { createBrowserRouter, Navigate } from 'react-router-dom';
import ProtectedRoute from '../components/ProtectedRoute';
import LoginPage from '../pages/Login';
import DashboardPage from '../pages/Dashboard';
import PoiManagementPage from '../pages/PoiManagement';
import PolicyManagementPage from '../pages/PolicyManagement';
import ChecklistManagementPage from '../pages/ChecklistManagement';
import CorrectionManagementPage from '../pages/CorrectionManagement';
import DiscoverManagementPage from '../pages/DiscoverManagement';
import RankManagementPage from '../pages/RankManagement';
import EmergencyManagementPage from '../pages/EmergencyManagement';
import PhrasesManagementPage from '../pages/PhrasesManagement';

export const router = createBrowserRouter([
  { path: '/', element: <Navigate to="/dashboard" replace /> },
  { path: '/login', element: <LoginPage /> },
  {
    path: '/dashboard',
    element: (
      <ProtectedRoute>
        <DashboardPage />
      </ProtectedRoute>
    ),
    children: [
      { index: true, element: <Navigate to="/dashboard/poi" replace /> },
      { path: 'poi', element: <PoiManagementPage /> },
      { path: 'policy', element: <PolicyManagementPage /> },
      { path: 'checklist', element: <ChecklistManagementPage /> },
      { path: 'correction', element: <CorrectionManagementPage /> },
      { path: 'discover', element: <DiscoverManagementPage /> },
      { path: 'rank', element: <RankManagementPage /> },
      { path: 'emergency', element: <EmergencyManagementPage /> },
      { path: 'phrases', element: <PhrasesManagementPage /> },
    ],
  },
  { path: '*', element: <Navigate to="/dashboard" replace /> },
]);
