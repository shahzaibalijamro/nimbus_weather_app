import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/controllers/auth_controller.dart';
import 'package:untitled/controllers/favorites_controller.dart';
import 'package:untitled/controllers/main_controller.dart';
import 'package:untitled/controllers/settings_controller.dart';
import 'package:untitled/widgets/favorites/log_out_dialogue.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  final FavoritesController favController =
      Get.isRegistered<FavoritesController>()
      ? Get.find<FavoritesController>()
      : Get.put(FavoritesController());
  final SettingsController settingsController =
      Get.isRegistered<SettingsController>()
      ? Get.find<SettingsController>()
      : Get.put(SettingsController(), permanent: true);

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _formatJoinDate(DateTime? date) {
    if (date == null) return 'Recently';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return 'Joined ${months[date.month - 1]} ${date.year}';
  }

  void _openEditProfileSheet(BuildContext context) {
    final nameController = TextEditingController(
      text: authController.user.value?.name ?? '',
    );
    final emailController = TextEditingController(
      text: authController.user.value?.email ?? '',
    );
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final RxBool showPasswordFields = false.obs;
    final RxBool isNewPasswordObscured = true.obs;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.dragHandleColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Profile',
                    style: GoogleFonts.sora(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        PhosphorIconsBold.x,
                        size: 18,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Full Name
              Text(
                'Full Name',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                cursorColor: AppColors.blue,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: AppColors.primaryText,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.backgroundColor,
                  prefixIcon: const Icon(
                    PhosphorIconsBold.user,
                    size: 18,
                    color: AppColors.secondaryText,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.blue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Email
              Text(
                'Email Address',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: AppColors.blue,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: AppColors.primaryText,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.backgroundColor,
                  prefixIcon: const Icon(
                    PhosphorIconsBold.envelope,
                    size: 18,
                    color: AppColors.secondaryText,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.blue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Change Password Toggle
              Obx(
                () => InkWell(
                  onTap: () {
                    showPasswordFields.value = !showPasswordFields.value;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          showPasswordFields.value
                              ? PhosphorIconsBold.caretDown
                              : PhosphorIconsBold.caretRight,
                          size: 16,
                          color: AppColors.blue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          showPasswordFields.value
                              ? 'Hide password change'
                              : 'Change password (optional)',
                          style: GoogleFonts.dmSans(
                            color: AppColors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Optional Password Fields
              Obx(() {
                if (!showPasswordFields.value) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Current Password',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: currentPasswordController,
                      obscureText: true,
                      cursorColor: AppColors.blue,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.backgroundColor,
                        hintText: 'Enter current password',
                        hintStyle: GoogleFonts.dmSans(
                          color: AppColors.mutedText,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          PhosphorIconsBold.lockKey,
                          size: 18,
                          color: AppColors.secondaryText,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.borderGrey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.blue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'New Password',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: newPasswordController,
                      obscureText: isNewPasswordObscured.value,
                      cursorColor: AppColors.blue,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.backgroundColor,
                        hintText: 'Minimum 6 characters',
                        hintStyle: GoogleFonts.dmSans(
                          color: AppColors.mutedText,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          PhosphorIconsBold.lock,
                          size: 18,
                          color: AppColors.secondaryText,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            isNewPasswordObscured.value =
                                !isNewPasswordObscured.value;
                          },
                          child: Icon(
                            isNewPasswordObscured.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.secondaryText,
                            size: 18,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.borderGrey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.blue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 22),

              // Save Button
              InkWell(
                onTap: () async {
                  if (nameController.text.trim().isEmpty) {
                    Get.rawSnackbar(
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.errorBg,
                      messageText: Text(
                        'Name cannot be empty',
                        style: GoogleFonts.dmSans(color: AppColors.errorText),
                      ),
                      margin: const EdgeInsets.all(12),
                      borderRadius: 12,
                    );
                    return;
                  }
                  if (emailController.text.trim().isEmpty) {
                    Get.rawSnackbar(
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.errorBg,
                      messageText: Text(
                        'Email cannot be empty',
                        style: GoogleFonts.dmSans(color: AppColors.errorText),
                      ),
                      margin: const EdgeInsets.all(12),
                      borderRadius: 12,
                    );
                    return;
                  }

                  final success = await authController.updateProfile(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    currentPassword: currentPasswordController.text.isNotEmpty
                        ? currentPasswordController.text
                        : null,
                    newPassword: newPasswordController.text.isNotEmpty
                        ? newPasswordController.text
                        : null,
                  );

                  if (success) {
                    Get.back();
                    Get.rawSnackbar(
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.blue,
                      messageText: Text(
                        'Profile updated successfully!',
                        style: GoogleFonts.dmSans(color: AppColors.white),
                      ),
                      margin: const EdgeInsets.all(12),
                      borderRadius: 12,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Obx(
                      () => authController.isUpdatingProfile.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              'Profile',
              style: GoogleFonts.sora(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Account settings, preferences, and session',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),

            // User Identity Card
            Obx(() {
              final user = authController.user.value;
              final name = user?.name ?? 'Nimbus Explorer';
              final email = user?.email ?? 'user@nimbus.app';
              final createdAt = user?.createdAt;

              final isDemo = (email.toLowerCase().trim() == 'demo@nimbus.app');

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar Circle
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5B8DFF), Color(0xFF1D4FD8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blue.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _getInitials(name),
                              style: GoogleFonts.sora(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.sora(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                email,
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  color: AppColors.secondaryText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.rainBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _formatJoinDate(createdAt),
                                  style: GoogleFonts.dmSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!isDemo) ...[
                      const SizedBox(height: 18),
                      // Edit Profile Action Button
                      InkWell(
                        onTap: () => _openEditProfileSheet(context),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderGrey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                PhosphorIconsBold.pencilSimple,
                                size: 16,
                                color: AppColors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Edit Profile',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderGrey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              PhosphorIconsBold.shieldCheck,
                              size: 16,
                              color: AppColors.secondaryText,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Demo Account (Read-Only)',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // Quick Stats Row
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (Get.isRegistered<MainController>()) {
                        Get.find<MainController>().switchScreens(
                          1,
                        ); // switch to Favorites tab
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.borderGrey.withValues(alpha: 0.7),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.errorBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              PhosphorIconsFill.heart,
                              size: 18,
                              color: AppColors.errorText,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => Text(
                              '${favController.favorites.length}',
                              style: GoogleFonts.sora(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                          Text(
                            'Saved Cities',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    final isFahr = settingsController.isFahrenheit.value;
                    return InkWell(
                      onTap: () => settingsController.toggleUnit(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.borderGrey.withValues(alpha: 0.7),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.sunBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                PhosphorIconsBold.thermometer,
                                size: 18,
                                color: Color(0xFFB54708),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isFahr ? '°F' : '°C',
                              style: GoogleFonts.sora(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryText,
                              ),
                            ),
                            Text(
                              isFahr ? 'Units: Fahrenheit' : 'Units: Celsius',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: AppColors.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Session & Backend Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.borderGrey.withValues(alpha: 0.7),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF12B76A), // Emerald green
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Persistent Session · 30 Days',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF027A48),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Connected to custom Nimbus API with live Open-Meteo forecasts and permanent database storage.',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Preferences Section Title
            Text(
              'Preferences & Info',
              style: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),

            // Preferences Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.borderGrey.withValues(alpha: 0.7),
                ),
              ),
              child: Column(
                children: [
                  // Units toggle item
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              PhosphorIconsBold.thermometer,
                              size: 20,
                              color: AppColors.blue,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Temperature Unit',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          final isFahr = settingsController.isFahrenheit.value;
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderGrey),
                            ),
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () =>
                                      settingsController.setFahrenheit(false),
                                  borderRadius: BorderRadius.circular(9),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !isFahr
                                          ? AppColors.blue
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Text(
                                      '°C',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: !isFahr
                                            ? Colors.white
                                            : AppColors.secondaryText,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      settingsController.setFahrenheit(true),
                                  borderRadius: BorderRadius.circular(9),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isFahr
                                          ? AppColors.blue
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Text(
                                      '°F',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isFahr
                                            ? Colors.white
                                            : AppColors.secondaryText,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.borderGrey),

                  // Data Source
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              PhosphorIconsBold.database,
                              size: 20,
                              color: AppColors.blue,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Weather Source',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Open-Meteo API',
                          style: GoogleFonts.dmMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.borderGrey),

                  // App Version
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              PhosphorIconsBold.info,
                              size: 20,
                              color: AppColors.blue,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Nimbus Version',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'v1.0.0',
                          style: GoogleFonts.dmMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Log Out Button
            InkWell(
              onTap: () => showLogOutDialog(),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.errorText.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      PhosphorIconsBold.signOut,
                      size: 18,
                      color: AppColors.errorText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.errorText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
