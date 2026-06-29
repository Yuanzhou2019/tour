import { ProLayout } from '@ant-design/pro-components';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';

const route = {
  path: '/dashboard',
  routes: [
    { path: '/dashboard/poi', name: 'POI 管理' },
    { path: '/dashboard/policy', name: '政策管理' },
    { path: '/dashboard/checklist', name: '清单管理' },
    { path: '/dashboard/correction', name: '纠错审核' },
    { path: '/dashboard/discover', name: '发现卡片' },
    { path: '/dashboard/rank', name: '榜单管理' },
    { path: '/dashboard/emergency', name: '紧急联系' },
    { path: '/dashboard/phrases', name: '常用语库' },
  ],
};

export default function DashboardPage() {
  const navigate = useNavigate();
  const location = useLocation();

  return (
    <ProLayout
      title="Sightour 管理后台"
      layout="mix"
      location={{ pathname: location.pathname }}
      route={route}
      menu={{ type: 'group' }}
      token={{ bgLayout: '#f5f7fa' }}
      menuItemRender={(item, dom) => (
        <div
          onClick={() => item.path && navigate(item.path)}
          style={{ cursor: 'pointer' }}
        >
          {dom}
        </div>
      )}
    >
      <Outlet />
    </ProLayout>
  );
}
