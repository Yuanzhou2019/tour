import { App, Form, Input, InputNumber, Modal, Select } from 'antd';
import { useEffect } from 'react';
import http from '../../services/http';
import RichTextEditor from '../../components/RichTextEditor';
import type { Poi } from '../../types';

interface Props {
  open: boolean;
  poi?: Poi;
  onClose: () => void;
  onSuccess: () => void;
}

const categories = [
  { label: '景点', value: 'attraction' },
  { label: '餐饮', value: 'dining' },
  { label: '住宿', value: 'lodging' },
  { label: '购物', value: 'shopping' },
];

const cities = [
  { label: '上海', value: 'SH' },
  { label: '北京', value: 'BJ' },
  { label: '广州', value: 'GZ' },
];

export default function PoiForm({ open, poi, onClose, onSuccess }: Props) {
  const [form] = Form.useForm();
  const { message } = App.useApp();
  const isEdit = !!poi;

  useEffect(() => {
    if (open) {
      if (poi) {
        form.setFieldsValue(poi);
      } else {
        form.resetFields();
      }
    }
  }, [open, poi, form]);

  const onFinish = async (values: Record<string, unknown>) => {
    try {
      if (isEdit) {
        await http.patch(`/pois/${poi!.id}`, values);
      } else {
        await http.post('/pois', values);
      }
      message.success(isEdit ? '修改成功' : '创建成功');
      onSuccess();
    } catch {
      message.error('保存失败');
    }
  };

  return (
    <Modal
      title={isEdit ? '编辑 POI' : '新增 POI'}
      open={open}
      onCancel={onClose}
      onOk={() => form.submit()}
      width={700}
      destroyOnClose
    >
      <Form form={form} layout="vertical" onFinish={onFinish}>
        <Form.Item name="nameZh" label="中文名称" rules={[{ required: true }]}>
          <Input />
        </Form.Item>
        <Form.Item name="nameEn" label="英文名称" rules={[{ required: true }]}>
          <Input />
        </Form.Item>
        <Form.Item name="addressZh" label="中文地址">
          <Input />
        </Form.Item>
        <Form.Item name="addressEn" label="英文地址">
          <Input />
        </Form.Item>
        <Form.Item name="lat" label="纬度" rules={[{ required: true }]}>
          <InputNumber style={{ width: '100%' }} />
        </Form.Item>
        <Form.Item name="lng" label="经度" rules={[{ required: true }]}>
          <InputNumber style={{ width: '100%' }} />
        </Form.Item>
        <Form.Item name="category" label="分类" rules={[{ required: true }]}>
          <Select options={categories} />
        </Form.Item>
        <Form.Item name="city" label="城市" rules={[{ required: true }]}>
          <Select options={cities} />
        </Form.Item>
        <Form.Item name="contact" label="联系方式">
          <Input />
        </Form.Item>
        <Form.Item name="openHours" label="营业时间">
          <Input />
        </Form.Item>
        <Form.Item name="descriptionZh" label="中文描述">
          <RichTextEditor placeholder="请输入中文描述..." />
        </Form.Item>
        <Form.Item name="descriptionEn" label="英文描述">
          <RichTextEditor placeholder="请输入英文描述..." />
        </Form.Item>
      </Form>
    </Modal>
  );
}
