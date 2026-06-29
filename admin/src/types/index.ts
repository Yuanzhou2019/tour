export interface AdminUser {
  id: string;
  username: string;
  role: string;
}

export interface LoginResponse {
  accessToken: string;
  user: AdminUser;
}

export interface ApiError {
  code: string;
  message: string;
  details?: Record<string, unknown>;
}

export interface ApiResponse<T> {
  data: T;
  meta?: {
    page: number;
    pageSize: number;
    total: number;
  };
}

// --- Domain models ---

export interface Policy {
  id: string;
  country: string;
  reason: string;
  category: string;
  titleZh: string;
  titleEn: string;
  contentZh: string;
  contentEn: string;
  sourceUrl?: string;
  sourceName?: string;
  updatedAt: string;
  createdAt: string;
}

export interface Checklist {
  id: string;
  country: string;
  reason: string;
  city: string;
  titleZh: string;
  titleEn: string;
  items: ChecklistItem[];
}

export interface ChecklistItem {
  id: string;
  titleZh: string;
  titleEn: string;
  detailZh?: string;
  detailEn?: string;
  officialUrl?: string;
  order: number;
  checked?: boolean;
}

export interface Poi {
  id: string;
  nameZh: string;
  nameEn: string;
  addressZh: string;
  addressEn: string;
  lat: number;
  lng: number;
  category: string;
  city: string;
  contact?: string;
  openHours?: string;
  imageUrls: string[];
  descriptionZh?: string;
  descriptionEn?: string;
  tags?: PoiTag[];
  reputation?: PoiReputation;
}

export interface PoiTag {
  id: string;
  tagKey: string;
  category: 'positive' | 'warning' | 'risk';
  labelZh: string;
  labelEn: string;
}

export interface PoiReputation {
  id: string;
  overallScore: number;
  foreignFriendly: number;
  languageSupport: number;
  paymentEase: number;
  authenticity: number;
  value: number;
  officialVerified: boolean;
  experienceTipsZh: string[];
  experienceTipsEn: string[];
  updatedAt: string;
}

export interface DiscoverCard {
  id: string;
  category: 'curated' | 'authentic' | 'heads_up';
  titleZh: string;
  titleEn: string;
  summaryZh: string;
  summaryEn: string;
  imageUrl: string;
  relatedPoiIds: string[];
  order: number;
}

export interface Rank {
  id: string;
  category: string;
  titleZh: string;
  titleEn: string;
  items: RankItem[];
  order: number;
  updatedAt: string;
}

export interface RankItem {
  poiId: string;
  reasonZh: string;
  reasonEn: string;
  order: number;
}

export interface Correction {
  id: string;
  anonymousId: string;
  type: 'content_error' | 'policy' | 'poi' | 'phrase' | 'other';
  targetId?: string;
  message: string;
  contactEmail?: string;
  status: 'queued' | 'reviewing' | 'resolved' | 'rejected';
  reviewerId?: string;
  reviewNote?: string;
  createdAt: string;
  updatedAt: string;
}

export interface EmergencyContact {
  id: string;
  country: string;
  type: 'police' | 'medical' | 'fire' | 'consulate' | 'tourist_hotline';
  nameZh: string;
  nameEn: string;
  phone: string;
  addressZh?: string;
  addressEn?: string;
}

export interface Phrase {
  id: string;
  category: string;
  en: string;
  zh: string;
  pinyin: string;
  order: number;
}

export interface FxRate {
  fromCurrency: string;
  toCurrency: string;
  rate: number;
  updatedAt: string;
}
