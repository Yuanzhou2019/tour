import { ProLayout } from '@ant-design/pro-components';
import { Button } from 'antd';
import { useAuthStore } from '../../store/authStore';

const menuRoute = {
  path: '/dashboard',
  routes: [
    { path: '/dashboard', name: 'Overview' },
    { path: '/dashboard/poi', name: 'POI Management' },
    { path: '/dashboard/policy', name: 'Policy' },
    { path: '/dashboard/rank', name: 'Ranks' },
    { path: '/dashboard/correction', name: 'Corrections' },
  ],
};

export default function DashboardPage() {
  const clear = useAuthStore((s) => s.clear);

  return (
    <ProLayout
      title="Sightour Admin"
      layout="mix"
      location={{ pathname: '/dashboard' }}
      route={menuRoute}
      menu={{ type: 'group' }}
      token={{ bgLayout: '#f5f7fa' }}
    >
      <div style={{ padding: 24 }}>
        <h1>Sightour Admin · v0.1</h1>
        <p>Stage 0 scaffold. Modules wired in Stage 3 (Task 34).</p>
        <Button onClick={clear} danger>
          Sign out
        </Button>
      </div>
    </ProLayout>
  );
}
