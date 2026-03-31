# ⚡ Apex Lookup

A professional Salesforce project demonstrating **Apex Lookups** with
Lightning Web Components (LWC), built from scratch using Salesforce CLI.

---

## 📦 Project Structure
```
force-app/main/default/
├── classes/
│   ├── LookupSearchResult.cls              ← Wrapper class
│   ├── AccountLookupController.cls         ← Single object lookup
│   ├── AccountLookupController.cls         ← Single object lookup
│   ├── MultiObjectLookupController.cls     ← Multi object lookup
│   ├── LookupControllerTest.cls            ← Tests (100% pass)
│   └── MultiObjectLookupControllerTest.cls ← Tests (100% pass)
└── lwc/
    └── lookupComponent/                    ← LWC Search Component
```

---

## ✨ Features

- 🔍 Real-time search with debouncing (300ms delay)
- 📦 Wrapper class pattern for clean data transfer
- 🔒 Security enforced SOQL queries
- 🎯 Single object lookup (Account)
- 🌐 Multi object lookup (Account + Contact + Opportunity)
- 💊 Pill selection with remove functionality
- ⚡ Cached Apex methods for performance
- ✅ 100% test pass rate (11 tests)

---

## 🏗️ Architecture
```
LWC Component
     │
     │  @AuraEnabled(cacheable=true)
     ▼
Apex Controller
     │
     │  SOQL with SECURITY_ENFORCED
     ▼
Salesforce Database
     │
     │  List<LookupSearchResult>
     ▼
LWC Component (renders results)
```

---

## 🚀 Setup & Deployment

### Prerequisites
- Salesforce CLI
- VS Code
- Git
- Salesforce Developer Org

### Steps

**1. Clone the repo**
```bash
git clone https://github.com/Peer-Abbas/apex-lookup.git
cd apex-lookup
```

**2. Authorize your Salesforce org**
```bash
sf org login web --alias lookup-org --set-default
```

**3. Deploy all classes**
```bash
sf project deploy start --source-dir force-app
```

**4. Run all tests**
```bash
sf apex run test --class-names LookupControllerTest --result-format human --wait 2
sf apex run test --class-names MultiObjectLookupControllerTest --result-format human --wait 2
```

---

## 🧪 Test Results
```
LookupControllerTest
✅ testSearchReturnsResults        Pass
✅ testSearchExcludesSelectedIds   Pass
✅ testSearchNoMatch               Pass
✅ testSearchReturnsMultiple       Pass
✅ testSubtitleFormat              Pass
Pass Rate: 100%

MultiObjectLookupControllerTest
✅ testSearchFindsAccount          Pass
✅ testSearchFindsContact          Pass
✅ testSearchFindsOpportunity      Pass
✅ testSearchExcludesSelectedIds   Pass
✅ testNoMatchReturnsEmpty         Pass
✅ testMixedResultsReturned        Pass
Pass Rate: 100%
```

---

## 💡 Key Concepts

| Concept | Description |
|---|---|
| Wrapper Class | Custom Apex class to structure return data |
| @AuraEnabled | Exposes Apex methods to LWC |
| SOQL Security | WITH SECURITY_ENFORCED + escapeSingleQuotes |
| Debouncing | Delays search to reduce server calls |
| @TestSetup | Shared test data setup method |
| LWC Events | CustomEvent for parent-child communication |

---

## 👨‍💻 Author

**Peer Abbas**
- GitHub: [@Peer-Abbas](https://github.com/Peer-Abbas)
- Email: peerabbasalishaah@gmail.com

---

## 📚 References

- [Salesforce LWC Documentation](https://developer.salesforce.com/docs/component-library)
- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode)
