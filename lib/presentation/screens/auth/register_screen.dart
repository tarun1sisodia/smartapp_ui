import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  final UserRole role;

  const RegisterScreen({super.key, required this.role});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _courseController = TextEditingController();
  final _academicYearController = TextEditingController();
  final _phoneController = TextEditingController();
  final _highestDegreeController = TextEditingController();
  final _experienceController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _rollNumberController.dispose();
    _courseController.dispose();
    _academicYearController.dispose();
    _phoneController.dispose();
    _highestDegreeController.dispose();
    _experienceController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.role == UserRole.teacher) {
        context.read<AuthBloc>().add(
              RegisterTeacherEvent(
                fullName: _fullNameController.text,
                username: _usernameController.text,
                email: _emailController.text,
                phone: _phoneController.text,
                highestDegree: _highestDegreeController.text,
                experience: _experienceController.text,
                password: _passwordController.text,
              ),
            );
      } else {
        context.read<AuthBloc>().add(
              RegisterStudentEvent(
                fullName: _fullNameController.text,
                rollNumber: _rollNumberController.text,
                course: _courseController.text,
                academicYear: _academicYearController.text,
                phone: _phoneController.text,
                password: _passwordController.text,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.role == UserRole.teacher ? 'Teacher' : 'Student'} Registration'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is OTPSentState) {
            Navigator.pushNamed(
              context,
              '/verify-otp',
              arguments: state.userId,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    label: 'Full Name',
                    controller: _fullNameController,
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  if (widget.role == UserRole.teacher) ...[
                    CustomTextField(
                      label: 'Username',
                      controller: _usernameController,
                      prefixIcon: const Icon(Icons.alternate_email),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value!)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      label: 'Highest Degree',
                      controller: _highestDegreeController,
                      prefixIcon: const Icon(Icons.school_outlined),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your highest degree';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      label: 'Experience',
                      controller: _experienceController,
                      prefixIcon: const Icon(Icons.work_outline),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your experience';
                        }
                        return null;
                      },
                    ),
                  ] else ...[
                    CustomTextField(
                      label: 'Roll Number',
                      controller: _rollNumberController,
                      prefixIcon: const Icon(Icons.numbers),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your roll number';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      label: 'Course',
                      controller: _courseController,
                      prefixIcon: const Icon(Icons.school_outlined),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your course';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      label: 'Academic Year',
                      controller: _academicYearController,
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your academic year';
                        }
                        return null;
                      },
                    ),
                  ],
                  CustomTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a password';
                      }
                      if (value!.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Register',
                    onPressed: _handleSubmit,
                    isLoading: state is AuthLoading,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          '/login',
                        ),
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
