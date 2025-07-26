# 🍽️ African Meal Planner

A comprehensive mobile and web application for discovering, planning, and preparing authentic African cuisine. Built with React Native (Expo) and Django, featuring AI-powered recommendations and seamless meal planning.

## 🌟 Features

### 🥘 Recipe Management
- **Extensive African Recipe Database** - Dishes from across the continent
- **Cultural Context** - Learn about the history and traditions behind each dish
- **Difficulty Levels** - From beginner-friendly to master chef recipes
- **Nutritional Information** - Complete breakdown of calories, macros, and nutrients

### 🤖 AI-Powered Features
- **Smart Recipe Recommendations** - Personalized suggestions based on your preferences
- **Meal Plan Generation** - AI creates weekly meal plans tailored to your goals
- **Ingredient Substitutions** - Find alternatives for hard-to-find ingredients
- **Cooking Tips** - Context-aware assistance while cooking

### 📱 User Experience
- **Cross-Platform** - Works on iOS, Android, and Web
- **Offline Mode** - Access saved recipes without internet
- **Shopping Lists** - Auto-generated from your meal plans
- **Progress Tracking** - Monitor your cooking journey and achievements

### 🏥 Health & Nutrition
- **Dietary Restrictions** - Support for various dietary needs
- **Allergy Management** - Safe recipe filtering
- **Calorie Tracking** - Monitor your daily intake
- **Health Goal Integration** - Align meals with fitness objectives

## 🚀 Tech Stack

### Frontend
- **React Native** with Expo
- **TypeScript**
- **Expo Router** for navigation
- **React Native Reanimated** for smooth animations
- **Supabase JS Client** for real-time data

### Backend
- **Django 4.2+** with Django REST Framework
- **PostgreSQL** (Supabase) / SQLite (Development)
- **Celery** for background tasks
- **OpenAI API** for AI features
- **Python 3.8+**

### Infrastructure
- **Supabase** for database and authentication
- **Redis** for caching and task queue
- **GitHub** for version control

## 📦 Installation

### Prerequisites
- Node.js 18+ and npm
- Python 3.8+
- Git
- Expo CLI (`npm install -g @expo/cli`)

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/african-meal-planner.git
cd african-meal-planner
```

### 2. Frontend Setup
```bash
# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Configure your Supabase credentials in .env
# EXPO_PUBLIC_SUPABASE_URL=your-supabase-url
# EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key

# Start the development server
npm run dev
```

### 3. Backend Setup
```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create environment file
cp .env.example .env

# Configure your environment variables in backend/.env

# Run migrations
python manage.py migrate

# Create superuser (optional)
python manage.py createsuperuser

# Start development server
python manage.py runserver
```

## 🔧 Configuration

### Environment Variables

#### Frontend (.env)
```env
EXPO_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
EXPO_PUBLIC_API_URL=http://localhost:8000/api
```

#### Backend (backend/.env)
```env
SECRET_KEY=your-django-secret-key
DEBUG=True
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
SUPABASE_DB_HOST=db.your-project.supabase.co
SUPABASE_DB_PASSWORD=your-db-password
OPENAI_API_KEY=your-openai-api-key
```

## 🏗️ Project Structure

```
african-meal-planner/
├── 📱 Frontend (React Native)
│   ├── app/              # Expo Router pages
│   ├── components/       # Reusable UI components
│   ├── contexts/         # React contexts
│   ├── hooks/           # Custom React hooks
│   ├── services/        # API and business logic
│   └── assets/          # Images, fonts, etc.
│
├── 🔧 Backend (Django)
│   ├── accounts/        # User management
│   ├── recipes/         # Recipe CRUD operations
│   ├── meal_planning/   # Meal plan management
│   ├── shopping/        # Shopping list features
│   ├── ai_engine/       # AI recommendations
│   ├── nutrition/       # Nutritional analysis
│   └── services/        # External API integrations
│
└── 📄 Documentation
    ├── README.md
    ├── SUPABASE_SETUP.md
    └── schema.sql
```

## 🔗 API Endpoints

### Authentication
- `POST /api/auth/register/` - User registration
- `POST /api/auth/login/` - User login
- `POST /api/auth/logout/` - User logout

### Recipes
- `GET /api/recipes/` - List recipes
- `POST /api/recipes/` - Create recipe
- `GET /api/recipes/{id}/` - Recipe details
- `POST /api/recipes/{id}/rate/` - Rate recipe

### Meal Planning
- `GET /api/meal-planning/` - List meal plans
- `POST /api/meal-planning/` - Create meal plan
- `GET /api/meal-planning/{id}/entries/` - Meal plan entries

### AI Features
- `POST /api/ai/recommend/` - Get AI recommendations
- `POST /api/ai/generate-meal-plan/` - Generate meal plan
- `POST /api/ai/substitute-ingredient/` - Find substitutions

## 🧪 Testing

### Frontend
```bash
# Run tests
npm test

# Run tests with coverage
npm test -- --coverage
```

### Backend
```bash
# Run Django tests
python manage.py test

# Run with coverage
coverage run --source='.' manage.py test
coverage report
```

## 🚀 Deployment

### Frontend (Vercel/Netlify)
```bash
# Build for web
npm run build:web

# Deploy to Vercel
npx vercel deploy
```

### Backend (Heroku/Railway)
```bash
# Install Heroku CLI and login
heroku create your-app-name
git push heroku main
```

## 📱 Mobile App

### Development Build
```bash
# Create development build
eas build --profile development

# Install on device
eas build:run -p android  # or ios
```

### Production Build
```bash
# Build for production
eas build --profile production

# Submit to stores
eas submit
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **African Culinary Heritage** - For the rich traditions that inspire this app
- **Supabase** - For providing excellent backend-as-a-service
- **Expo** - For making React Native development accessible
- **OpenAI** - For powering our AI recommendations

## 📞 Support

- 📧 Email: support@africanmealplanner.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/african-meal-planner/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/yourusername/african-meal-planner/discussions)

---

**Built with ❤️ for African cuisine enthusiasts worldwide** 🌍
